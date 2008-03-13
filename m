Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYCMTQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYCMTQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbYCMTP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:15:26 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:51666 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964AbYCMTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:15:25 -0400
Message-ID: <47D97C9E.303@emc.com>
Date: Thu, 13 Mar 2008 15:12:30 -0400
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Lars Marowsky-Bree <lmb@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <47D92BBB.6000203@emc.com> <200803131202.48135.phillips@phunq.net>
In-Reply-To: <200803131202.48135.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=0%, Reason='EMC_BODY_1+ -3, EMC_BODY_PROD_2+ -3, EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Thursday 13 March 2008 06:27, Ric Wheeler wrote:
>>>>> So "perfectly reliable if UPS power does not fail" seems a bit over the
>>>>> top.
>>>> It works for EMC :-)
>>> Where they control the hardware and run a rather specialized OS as well,
>>> not a general purpose system like Linux on "commodity" hardware ;-)
>> Actually, in Centera we use generic hardware with a fairly normal kernel 
>> which has strategic backports from upstream (libata, nic drivers, etc).
>>
>> No UPS in the picture.  Data integrity is protected by working with the 
>> application team to insure they understand when data is safely on the 
>> disk platter and working with IO & FS people to try and make sure we 
>> don't lie to them (too much ) about that promise.
>>
>> The centera boxes are tested with power failure & error injection and by 
>> all of our customers in all those ways customers do ;-)
> 
> Hi Ric,
> 
> Right, so Linux has gotten to the point where it competes with purpose-
> built embedded software in reliability.  Not quite there, but close
> enough for mission-critical.

This is our case, but we have been working for quite a while to enhance 
the reliability of the io stack & file systems. It also helps to be very 
careful to select hardware components with mature, open source & 
natively integrated drivers ;-)


> 
> I was not thinking of Centera when I mentioned the UPS though...
> 
> Daniel

No problem, we certainly have many boxes with built in ups hardware ;-)

ric
