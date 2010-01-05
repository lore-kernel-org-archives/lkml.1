Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545Ab0AECgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0AECgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224Ab0AECgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:36:08 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4705 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0AECgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:36:07 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Naren (Narendra) Sankar" <nsankar@broadcom.com>
To: "Robert Hancock" <hancockrwd@gmail.com>, "Jarod Wilson" <jarod@redhat.com>
cc: "Greg KH" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Scott Davilla" <davilla@4pi.com>,
       "Manu Abraham" <abraham.manu@gmail.com>
Date: Mon, 4 Jan 2010 18:36:01 -0800
Subject: RE: [PATCH v3] staging: add Broadcom Crystal HD driver
Thread-Topic: [PATCH v3] staging: add Broadcom Crystal HD driver
Thread-Index: AcqNrdk2wJ92LIm6Q/m/tW5n1DWp9gAAbmYQ
Message-ID: <80A6ED01A151614884EE6C5D6AF0F2E90460D23460@SJEXCHCCR01.corp.ad.broadcom.com>
References: <20100104230227.GA14314@redhat.com>
 <20100104231949.GA14496@kroah.com> <4B427AF5.2030805@redhat.com>
 <4B42A23B.4080704@gmail.com>
In-Reply-To: <4B42A23B.4080704@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 675C7A193J860217007-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The register bits come straight from the HW RTL. So this way there are no errors or typos. It would be easier for maintenance from our side since this is generated automagically. And when we add new HW, again it is a script that spews this out.

Not absolutely necessary, but worried that cleanups may cause more problems than fix. 


Naren Sankar (+1 408 218 6327)
Architect/PLM
Media PC, Broadband Communications Group
Broadcom Corp.

-----Original Message-----
From: Robert Hancock [mailto:hancockrwd@gmail.com] 
Sent: Monday, January 04, 2010 6:22 PM
To: Jarod Wilson
Cc: Greg KH; linux-kernel@vger.kernel.org; Scott Davilla; Naren (Narendra) Sankar; Manu Abraham
Subject: Re: [PATCH v3] staging: add Broadcom Crystal HD driver

On 01/04/2010 05:34 PM, Jarod Wilson wrote:
> On 1/4/10 6:19 PM, Greg KH wrote:
>> On Mon, Jan 04, 2010 at 06:02:27PM -0500, Jarod Wilson wrote:
>>> This patch supersedes the earlier ones sent by Manu Abraham to add
>>> the Broadcom Crystal HD driver to the staging tree, per discussion
>>> with him about it. I've been working with Broadcom's Naren Sankar
>>> on this driver for a number of months, and had already talked Naren
>>> about submitting this on Broadcom's behalf, didn't expect anyone
>>> else to jump on submitting it as quickly as Manu did. ;)
>>
>> Looks good, I'll queue it up tomorrow.
>
> Nb: it looks like the thing is so massive (~935k), its not showing up on
> lkml (at least, not in a timely fashion), so for the interested:
>
> <http://people.redhat.com/jwilson/misc/broadcom-crystalhd-decoder-driver-staging.patch>
>
> Thanks much!

Literally the majority of the code is #defines for what looks like 
register bits, etc - is all that really necessary?


