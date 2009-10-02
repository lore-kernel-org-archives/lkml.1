Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbZJBFeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbZJBFeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 01:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbZJBFep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 01:34:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50737 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280AbZJBFeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 01:34:44 -0400
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <20091002012911.GA18542@kroah.com>
	<m1tyyixuc1.fsf@fess.ebiederm.org> <20091002051056.GA7181@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 01 Oct 2009 22:34:42 -0700
In-Reply-To: <20091002051056.GA7181@suse.de> (Greg KH's message of "Thu\, 1 Oct 2009 22\:10\:56 -0700")
Message-ID: <m1ljjuxsst.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [000/136] 2.6.31.2-stable review
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Thu, Oct 01, 2009 at 10:01:34PM -0700, Eric W. Biederman wrote:
>> Greg KH <gregkh@suse.de> writes:
>> 
>> > Note from the -stable maintainer on this release:
>> >
>> >   This release is big.  Yeah, really big.  There are a number of
>> >   areas that needed some rework in order to get things back to
>> >   working order.  Like the tty layer.  Hopefully everyone can now
>> >   use their usb to serial devices again without oopsing the
>> >   kernel
>> 
>> The ftdi_sio driver still crashes and burns.
>
> What were you doing when it crashed?  I tested the pl2303 device and it
> worked fine for me here, I don't have a ftdi_sio one :(

sending a line every 1/10 a second in both directions.  Plus I threw
in baud rate change every 20 seconds.  I can kill an ftdi_sio no time that way.

I think the change to disable low latency in ftdi_sio fixes that I am build
a kernel to check that now.

Eric
