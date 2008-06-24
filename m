Return-Path: <linux-kernel-owner+w=401wt.eu-S1751818AbYFXEGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbYFXEGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 00:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYFXEFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 00:05:54 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:5590 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYFXEFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 00:05:50 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Date: Tue, 24 Jun 2008 04:05:16 +0000
Subject: RE: [PATCH][resubmit] HP iLO driver
Thread-Topic: [PATCH][resubmit] HP iLO driver
Thread-Index: AcjVVy96yPXzimyyQLalVKmzqsjxQgAVZmHA
Message-ID: <CF70AA892F109448AEA269483B3A983903B70747D5@G1W1215.americas.hpqcorp.net>
References: <20080623160052.GA7616@ldl.fc.hp.com>
 <84144f020806231032t19120112jda26567037d722f2@mail.gmail.com>
In-Reply-To: <84144f020806231032t19120112jda26567037d722f2@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
>
> The upper case Q is not a proper local variable name (appears
> elsewhere as well).

Okay.

> Static inline functions are preferred over function-like macros.

I'll look at those.  I like macros, but if people feel strongly about
it, I'll convert them.  The ones that shift bits around seem like
macros, but the ones that make function calls should be functions.
