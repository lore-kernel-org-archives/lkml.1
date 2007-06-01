Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbXFAByx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbXFAByx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbXFAByp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:54:45 -0400
Received: from pool-151-205-99-173.ny325.east.verizon.net ([151.205.99.173]:50984
	"HELO gatworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751481AbXFAByo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:54:44 -0400
Message-ID: <465F7C2A.5020702@gatworks.com>
Date: Thu, 31 May 2007 21:53:46 -0400
From: Uncle George <netbeans@gatworks.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: davids@webmaster.com
CC: linux-kernel@vger.kernel.org
Subject: Re: SELECT() returns 1 But FIONREAD says (Input/output error)
References: <MDEHLPKNGKAHNMBLJOLKCENHEDAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCENHEDAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:

> Nope. An errored connection is always ready for read/write -- there is
> nothing to wait for as far as the kernel is concerned. Your code keeps
> asking the kernel if something interesting has happened, the kernel keeps
> telling it yes, and it refuses to do anything about it.
> 
The select() returns because i pulled the USB cable from hub. Seems 
reasonable.

The next select() found what? to be interesting in order to prematurely 
terminate the select-wait? As far as I can tell, nothing interesting has 
happened since the previous select(). In this case the select() is only 
looking at read()'s.
