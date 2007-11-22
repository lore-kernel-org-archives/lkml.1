Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbXKVQTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbXKVQTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 11:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbXKVQTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 11:19:46 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:15756 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbXKVQTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 11:19:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sW3SXRracUON807LTEZGhu/bDZFOsrgjyg5PYG5uou9FH1aB0mlBw9+U3sphHo/tYe9i9VhZu6X4j4ElVSgIjSDrHjneMkuMQpF12PhIlBEHSvWchpTjf3KNvtzFuilpCWR7Vj/2VyHDyvI/+/20pl4lm+qoIfD3aNvknRc02yg=
Message-ID: <c384c5ea0711220819j2fa19430sb54139191d181c3b@mail.gmail.com>
Date: Thu, 22 Nov 2007 17:19:44 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: Use of mutex in interrupt context flawed/impossible, need advice.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200711221711.39134.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c384c5ea0711220802i21e3df45q1d328aea63e7ebf4@mail.gmail.com>
	 <200711221711.39134.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Nov 22, 2007 5:11 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Donnerstag 22 November 2007 schrieb Leon Woestenberg:
> > I would like to know why this is not so, and if someone has a cleaner
> > proposal than the "try spinlock" approach?
>
> Keep the semaphore.
>
I forgot to mention that I would like to be prepared for, and use the
-rt patch soon. I understand (maybe wrongly?) that semaphores are not
real-time pre-emptible, mutexes and spinlocks are.

Regards,
-- 
Leon
