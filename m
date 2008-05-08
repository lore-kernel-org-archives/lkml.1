Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYEHA6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYEHA6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYEHA6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:58:38 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:64238 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbYEHA6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:58:36 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver - Resend
Date: Thu, 8 May 2008 08:58:31 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67855@exchtp03.taipei.via.com.tw>
In-Reply-To: <20080507140357.9320dfcd.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver - Resend
Thread-Index: AciwhfDHUgDHFgKGRfaPaBcxqtCbZAAIDCgA
From: <JosephChan@via.com.tw>
To: <akpm@linux-foundation.org>, <krzysztof.h1@poczta.fm>
Cc: <geert@linux-m68k.org>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 May 2008 00:58:34.0849 (UTC) FILETIME=[A45A2510:01C8B0A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks a lot.
I will check the the scripts/checkpatch.pl after the codes are modified. 

About the subject, that's my carelessness and I will correct them by your recommendation next time.

In addition, should I resend the patches after they are modified? Thanks.

BRs,
Joseph Chan 

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Thursday, May 08, 2008 5:04 AM
To: Krzysztof Helt
Cc: Joseph Chan; geert@linux-m68k.org; linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver - Resend

On Wed, 7 May 2008 18:43:33 +0200
Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:

> A general comment is that you use to many global variables.

yes, that was my first impression.  The _names_ of those variables is a real problem.  lcd_mode, DeviceStatus, second_size, primary_dev, etc.  The driver is attempting to reserve all those names for itself, kernel-wide.

So at a minimum, going through and prepending viafb_ onto all those would be needed.


There are a number of layout glitches in there.  Such as a strange combination of two styles:

void foo(void)
{

versus

void foo(void ) {

Many of these things can be pinpointed by processing the diff with scripts/checkpatch.pl.


Administrative note: all nine patches had the same title "viafb: VIA Frame Buffer Device Driver".  Please choose unique and meaningful names for each patch, such as "viafb: add utility header file".


Apart from those fairly easily-fixed things, the driver looks pretty good from a quick scan, given how large it is, and given that it probably has been around for quite a long time..

