Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYFAUNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYFAUNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYFAUNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:13:38 -0400
Received: from smtp106.prem.mail.sp1.yahoo.com ([98.136.44.61]:26305 "HELO
	smtp106.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751340AbYFAUNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:13:38 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2008 16:13:38 EDT
X-YMail-OSG: 3wCUUioVM1lLiux2O4QDrmWohU5WeSwD899RGIjuL7Ah7kjo8TWDjep35WnXRjc56DuTjsOZhH9R2kYFbcXJ5T43kNKl6piVXHOo3EPvb_u_zcSdZGnVwyKyqZk-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4843015D.4000600@schaufler-ca.com>
Date: Sun, 01 Jun 2008 13:06:53 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: casey@schaufler-ca.com, lcapitulino@mandriva.com.br,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc4: mount.ntfs-3g hangs when smack is enabled
References: <848198.48297.qm@web36608.mail.mud.yahoo.com>
In-Reply-To: <848198.48297.qm@web36608.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> --- Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>   
>>>  I'm not sure whether this is a smack problem, but Mandriva users are
>>> reporting that mount.ntfs-3g (ntfs driver, uses FUSE) hangs when
>>> they try to mount their NTFS partition.
>>>       
>> Yes, this is a smack/fuse interaction problem.  Also see this thread:
>>
>>   http://marc.info/?l=fuse-devel&m=120931855107469&w=2
>>
>> Casey, you were CC-d on the last mail in that thread.  Did you miss
>> that?
>>     
>
> Ok. I just set my a machine to try this on and with today's
> Linus git tree as the base I'm able to mount an NTFS file system
> just fine. Just to be perverse, the machine I'm working with
> has Oracle Enterprize 5 installed, with ntfsprogs-2.0.0. 
>
> How about a .config, lsmod, etc?
>
>   

Looks like a "never mind" with the .config etc as I've been able to 
reproduce the hang
by the simple process of using ntfs-3g, like you did. Thank you.

