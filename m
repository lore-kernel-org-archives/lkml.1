Return-Path: <linux-kernel-owner+w=401wt.eu-S938718AbXG1CnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938718AbXG1CnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 22:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbXG1Cm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 22:42:58 -0400
Received: from mail44.messagelabs.com ([216.82.249.179]:8798 "HELO
	mail44.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756857AbXG1Cm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 22:42:57 -0400
X-VirusChecked: Checked
X-Env-Sender: subbus@serverengines.com
X-Msg-Ref: server-7.tower-44.messagelabs.com!1185590575!29541401!1
X-StarScan-Version: 5.5.12.11; banners=-,-,-
X-Originating-IP: [68.165.1.68]
To: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Chris Friesen" <cfriesen@nortel.com>, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
From: "Subbu Seetharaman" <subbus@serverengines.com>
Subject: Re: Source organization for two drivers sharing coomon code
In-Reply-To: Pine.LNX.4.64.0707272131270.16356@fbirervta.pbzchgretzou.qr
Message-ID: <20070728024255.af17c314@mailhost.serverengines.com>
Date: Fri, 27 Jul 2007 19:42:55 -0700
X-User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; FunWebProducts; .NET CLR
	1.1.4322)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for all the answers.  The common code is mostly handling
the message passing for hardware  initialization, rings creation
and some ioctls.  drivers/message looks like a good place for this
code to live.

Subbu



From: Jan Engelhardt [mailto:jengelh@computergmbh.de]
To: Chris Friesen [mailto:cfriesen@nortel.com]
Cc: Subbu Seetharaman [mailto:subbus@serverengines.com], linux-kernel@vger.kernel.org
Sent: Fri, 27 Jul 2007 12:34:16 -0700
Subject: Re: Source organization for two drivers sharing coomon code


On Jul 27 2007 13:12, Chris Friesen wrote:
> Jan Engelhardt wrote:
>> On Jul 27 2007 10:17, Subbu Seetharaman wrote:
>> 
>> >What is the recommended way for two drivers to share common code ?
>> ><snip>...The source code for these dirvers will fit under drivers/net and
>> >drivers/scsi. But both drivers share some common code.
>
>> You could create (in total) three modules, e.g. my-common.ko,
>> my-net.ko and my-scsi.ko, of which the latter two use functions from the
>> first.
>
> Where would the common code live, in such a case? Would you just pick one of
> the two locations at random, or put it in drivers/misc or maybe lib?

Perhaps drivers/message - well I can't answer that exactly.

As far as the output object files are concerned, it is not relevant,
since they will be autoloaded anyway :)



Jan
-- 

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines LLC and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

