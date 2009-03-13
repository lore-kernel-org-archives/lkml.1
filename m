Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbZCMKTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbZCMKTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZCMKTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:19:25 -0400
Received: from ns.firmix.at ([62.141.48.66]:2947 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZCMKTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:19:24 -0400
Subject: Re: Network throughput (localhost)
From: Bernd Petrovitsch <bernd@firmix.at>
To: Aki Niimura <akineko@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <59f1f0cb0903130025k31cc2c9fud865dd776534c2bd@mail.gmail.com>
References: <59f1f0cb0903130025k31cc2c9fud865dd776534c2bd@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 13 Mar 2009 11:18:55 +0100
Message-Id: <1236939535.25161.17.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.054 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-1.054 required=5
X-Spam-Score: -1.054 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 00:25 -0700, Aki Niimura wrote:
[...]
> I developed a Python program, which tries to take advantage of
> available Multi CPU resources.
> Two programs (Server and Client) are running in separate processes
> communicating each other using Socket IPC.
> The performance I'm getting is somewhat in line with my expectation
> under Solaris/x86 but significantly slower
> under Linux (CentOS 5) even both use the identical hardware.
> 
> My investigation revealed that the performance is bottlenecked by the
> communication (Socket to localhost).
> 
> So, I wrote much simpler program (socket server and socket client) to
> measure the network throughput.
> What I found was that the network throughput on both platforms
> (Solaris/x86 and CentOS Linux) are almost
> identical if packets are going out but the network throughput of
> Solaris/x86 is almost twice (up to three times)
> the throughput Linux can deliver if the packets are destined to localhost.
> 
> I know that Solaris treats packets destined to localhost differently.
> 
> Because of this, my program is slower (than one process) under Linux
> (and is practically useless).
> (I see meaningful performance gain under Solaris/x86, though)
> I haven't tried any other Linux distributions.
> Is there any Linux distribution known for better localhost network throughput?
> Is there any way to improve the localhost throughput under Linux (CentOS)?
> 
> Of course, some people would point out that other types of IPC (such
> as shared memory) are better choices
> for the communication between closely coupled multi-processing
> program. Unfortunately, there are
> reasons that my program needs to use Socket.
> 
> Any suggestions will be greatly appreciated.

Have you tried AF_UNIX sockets?

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


