Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZBRAlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZBRAlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZBRAlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:41:45 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59028 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZBRAlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:41:44 -0500
To: John Ogness <dazukocode@ogness.net>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
References: <8663jrgwo4.fsf@johno.fn.ogness.net>
	<861vufgwlt.fsf@johno.fn.ogness.net>
	<86wsc7fhzc.fsf_-_@johno.fn.ogness.net>
	<86skmvfhx6.fsf_-_@johno.fn.ogness.net>
	<m1k57vcsr1.fsf@fess.ebiederm.org>
	<86fxidfnnh.fsf@johno.fn.ogness.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Feb 2009 16:41:58 -0800
In-Reply-To: <86fxidfnnh.fsf@johno.fn.ogness.net> (John Ogness's message of "Tue\, 17 Feb 2009 09\:55\:30 +0100")
Message-ID: <m1iqn8tw2x.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: dazukocode@ogness.net, alan@lxorguk.ukuu.org.uk, hch@infradead.org, eparis@redhat.com, malware-list@lists.printk.net, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;John Ogness <dazukocode@ogness.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCHv2 3/5] VFS: DazukoFS, stackable-fs, file access control
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Ogness <dazukocode@ogness.net> writes:

> On 2009-02-12, ebiederm@xmission.com (Eric W. Biederman) wrote:
>>> Patch 3: Creates /dev/dazukofs.ctrl to allow for groups to be added,
>>>          listed, and deleted. Also, /dev/dazukofs.[0-9] devices are
>>>          created to support multiple groups.
>>
>> Great another global namespace for process groups.  What is your
>> plan for making this work in a container?
>
> It is good that you mention it. This is something that I totally
> missed. I am not yet certain what kind of a role DazukoFS should have
> within containers.  I need to learn the container API's and see what
> kinds of options are available. The next patchset (which it seems
> won't be coming too quickly now) will address this in some form.

Per filesystem would be fine.

Eric
