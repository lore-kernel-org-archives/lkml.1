Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbZLaOd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbZLaOd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 09:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZLaOd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 09:33:58 -0500
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:44385 "HELO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752451AbZLaOd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 09:33:58 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] arch/powerpc/boot/devtree.c: use %pM to show MAC address
Date: Thu, 31 Dec 2009 09:33:55 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F6BB@mi8nycmail19.Mi8.com>
In-Reply-To: <20091231044926.GC18358@brick.ozlabs.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] arch/powerpc/boot/devtree.c: use %pM to show MAC address
Thread-Index: AcqJ2UQrI9RJjYpHRfeBvKnKxVFUwgATOB8g
References: <BD79186B4FD85F4B8E60E381CAEE19090200F65E@mi8nycmail19.Mi8.com> <20091231044926.GC18358@brick.ozlabs.ibm.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Paul Mackerras" <paulus@samba.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
X-OriginalArrivalTime: 31 Dec 2009 14:33:56.0671 (UTC) FILETIME=[48B544F0:01CA8A26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 30, 2009 9:49 PM, Paul Mackerras wrote:
> On Wed, Dec 30, 2009 at 02:30:39PM -0500, H Hartley Sweeten wrote:
>
>> Use the %pM kernel extension to display the MAC address.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> 
>> ---
>
> Nak - this isn't the kernel, this is a separate program, namely the
> bootwrapper that decompresses the kernel image, and it has its own
> printf (not printk) implementation in arch/powerpc/boot/stdio.c, which
> doesn't understand the %pX extensions (and I don't see any good reason
> to make it do so).

OK.  Sorry for the noise.

Regards,
Hartley
