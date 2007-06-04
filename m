Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbXFDVJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbXFDVJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXFDVJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:09:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42333 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751980AbXFDVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:09:09 -0400
Date: Mon, 4 Jun 2007 14:09:07 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: menage@google.com, vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net,
       balbir@in.ibm.com, haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, devel@openvz.org, ebiederm@xmission.com,
       mbligh@google.com, containers@lists.osdl.org, serue@us.ibm.com,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com, cpw@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process
 Containers
Message-Id: <20070604140907.7a15d9ad.pj@sgi.com>
In-Reply-To: <20070604205106.GA31530@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com>
	<20070604191412.GA901@sergelap.austin.ibm.com>
	<6599ad830706041332o718acb60ve0b5e38c2ca82c62@mail.gmail.com>
	<20070604205106.GA31530@sergelap.austin.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [root@linuz11 root]# rm -rf /containers/1 

No - not 'rm -fr'.

'rmdir'

Remove the cpuset directory, not start bottom up
trying to remove the files first.

The poor 'rm -fr' command doesn't understand the
rather odd nature of cpuset file systems, which
have all files coming and going automagically in
the middle of the night, and only allow mkdir and
rmdir operations, not creat or unlink.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
