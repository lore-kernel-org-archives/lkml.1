Return-Path: <linux-kernel-owner+w=401wt.eu-S1764892AbZDJLBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764892AbZDJLBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbZDJLBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:01:11 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:31973 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbZDJLBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:01:09 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <49DF26EB.4040106@tudelft.nl>
Date: Fri, 10 Apr 2009 13:00:59 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
Cc: Rafi Rubin <rafi@seas.upenn.edu>, Len Brown <len.brown@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Additional keys for dell-wmi
References: <200904082116.n38LG4Df012420@ampersand.seas.upenn.edu> <20090409153203.GB17194@srcf.ucam.org>
In-Reply-To: <20090409153203.GB17194@srcf.ucam.org>
Content-Type: multipart/mixed;
 boundary="------------040609080009050404050601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040609080009050404050601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Matthew Garrett schreef:
> On Wed, Apr 08, 2009 at 05:16:04PM -0400, Rafi Rubin wrote:
> 
>>  static struct key_entry dell_wmi_keymap[] = {
>>  	{KE_KEY, 0xe045, KEY_PROG1},
>> +	{KE_KEY, 0xe046, KEY_PROG2},
>> +	{KE_KEY, 0xe047, KEY_PROG3},
> 
> Would this make more sense as a switch? That way userspace can know what 
> state the screen is in.
> 
Indeed, that seems more logical. And in addition, there is a switch
called SW_TABLET_MODE, which would fit perfectly.
I guess at initialisation you can consider it is in standard mode, and
actually sort out the real state on the first event received.

Eric

--------------040609080009050404050601
Content-Type: text/x-vcard; charset=utf-8;
 name="E_A_B_Piel.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="E_A_B_Piel.vcf"

begin:vcard
fn;quoted-printable:=C3=89ric Piel
n;quoted-printable:Piel;=C3=89ric
org:Technical University of Delft;Software Engineering Research Group
adr:HB 08.080;;Mekelweg 4;Delft;;2628 CD;The Netherlands
email;internet:E.A.B.Piel@tudelft.nl
tel;work:+31 15 278 6338
tel;cell:+31 6 2437 9135
x-mozilla-html:FALSE
url:http://pieleric.free.fr
version:2.1
end:vcard


--------------040609080009050404050601--
