Return-Path: <linux-kernel-owner+w=401wt.eu-S934571AbZKYICV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571AbZKYICV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758391AbZKYICU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:02:20 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:14529 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323AbZKYICU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:02:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=Bh1OHYcLbPpG8aPwqDULFeJoX1Fu80XCpA/STOKtMDCmC0YC65Pj6C61FaLYCicxOW
         phtq2CotCO82ImdudxDVpMJhMF+vDSviRBoQ+vtFwJGfnduT65J4O+xOrAJJ6O78t3tn
         dM6w7imcK9kBO1U7es2tmPlRy+gl7FZKHRAOY=
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 16/38] move s3c_pwm_remove to .devexit.text
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-9-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-10-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-11-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-12-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-13-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-14-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-15-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259096853-18909-16-git-send-email-u.kleine-koenig@pengutronix.de>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Wed, 25 Nov 2009 09:02:20 +0100
In-Reply-To: <1259096853-18909-16-git-send-email-u.kleine-koenig@pengutronix.de> ("Uwe
 =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Tue\, 24 Nov 2009 22\:07\:11
 +0100")
Message-ID: <87tywjav77.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Uwe" == Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:

 Uwe> The function s3c_pwm_remove is used only wrapped by __devexit_p so define
 Uwe> it using __devexit.

 Uwe> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
 Uwe> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
