Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbYHNC0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbYHNC0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 22:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYHNC0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 22:26:06 -0400
Received: from main.gmane.org ([80.91.229.2]:46802 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYHNC0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 22:26:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: 7v5w7go9ub0o <7v5w7go9ub0o@gmail.com>
Subject: Re: TALPA - a threat model?  well sorta.
Date: Wed, 13 Aug 2008 22:25:49 -0400
Message-ID: <g8053f$osb$1@ger.gmane.org>
References: <1218645375.3540.71.camel@localhost.localdomain> <g7vtch$8v2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: delta513.server4you.de
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
In-Reply-To: <g7vtch$8v2$1@ger.gmane.org>
Cc: malware-list@lists.printk.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

7v5w7go9ub0o wrote:

> 
> 4. Again, my hope for libmalware.so/dazuko is a realtime
> integrity-management link.
> 
> <end posts>
> 
> HTH
> 
> p.s. The question has developed, should this monitor root activities. 
> IMHO, the answer is a definite YES!  We are most vulnerable during 
> software updating; AntiMailware signatures may stop the compilation or 
> installation of a Trojan - by root.
> 

I just noticed a separate discussion about integrity-checking LKMs and LSMs.

Obviously, a libmalware.so or Dazuko based integrity-checker would block 
a kernel from loading in a Trojaned LKM - noting that the MD5 had 
changed, and asking you to block, temporarily allow, or permanently 
allow the changed module.

Another security benefit of your pursuit.

HTH







