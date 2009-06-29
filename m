Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbZF2O4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbZF2O4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZF2O4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:56:17 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:40940 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZF2O4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:56:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BpEIEa1EHaLSehvvYHHVAHsQUHIoQqOd0vZw7Xtuu2wRYX21Uy1jOxioOtqve49rHQ
         jvsIxep8513FG0Tup8RVkU3j8NLK2kMLlviiW/RcsptscNFbBJThabX0QxGKhJNGQz2A
         Q/XgPZNk4Wi2gnGLbGeSFLsMyrFVyS2SynqdM=
MIME-Version: 1.0
In-Reply-To: <20090629145147.GA29433@localhost>
References: <20090620035504.GA19516@localhost>
	 <20090629093423.GB1315@localhost>
	 <a0272b440906290326rcd63849j2513f6ee9b9bf93e@mail.gmail.com>
	 <4A489DAC.7000007@vlnb.net> <20090629125434.GA8416@localhost>
	 <4A48BBF9.6050408@vlnb.net> <20090629131326.GA23668@localhost>
	 <20090629132841.GA26171@localhost>
	 <a0272b440906290743n5e089241x6e755115172a4a2a@mail.gmail.com>
	 <20090629145147.GA29433@localhost>
Date: Mon, 29 Jun 2009 16:56:18 +0200
Message-ID: <a0272b440906290756h203e7074j99b35f833e3b854d@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
From: Ronald Moesbergen <intercommit@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/29 Wu Fengguang <fengguang.wu@intel.com>:
> On Mon, Jun 29, 2009 at 10:43:48PM +0800, Ronald Moesbergen wrote:
>> 2009/6/29 Wu Fengguang <fengguang.wu@intel.com>:
>> > On Mon, Jun 29, 2009 at 09:13:27PM +0800, Wu Fengguang wrote:
>> >> On Mon, Jun 29, 2009 at 09:04:57PM +0800, Vladislav Bolkhovitin wrote:
>> >> > Wu Fengguang, on 06/29/2009 04:54 PM wrote:
>> >> > >
>> >> > > Why not 2.6.30? :)
>> >> >
>> >> > We started with 2.6.29, so why not complete with it (to save additional
>> >> > Ronald's effort to move on 2.6.30)?
>> >>
>> >> OK, that's fair enough.
>> >
>> > btw, I backported the 2.6.31 context readahead patches to 2.6.29, just
>> > in case it will help the SCST performance.
>> >
>> > Ronald, if you run context readahead, please make sure that the server
>> > side readahead size is bigger than the client side readahead size.
>>
>> I tried this patch on a vanilla kernel and no other patches applied,
>> but it does not seem to help. The iSCSI throughput does not go above
>> 60MB/s. (1GB in 17 seconds). I have tried several readahead settings
>> from 128KB up to 4MB and kept the server readahead at twice the client
>> readahead, but it never comes above 60MB/s. This is using SCST on the
>
> OK, thanks for the tests anyway!

You're welcome.

>> serverside and openiscsi on the client. I get much better throughput
>> (90 MB/s) when using the patches supplied with SCST, together with the
>
> What do you mean by "patches supplied with SCST"?

These:
http://scst.svn.sourceforge.net/viewvc/scst/trunk/scst/kernel/

Regards,
Ronald.
