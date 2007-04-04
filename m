Return-Path: <linux-kernel-owner+w=401wt.eu-S2992735AbXDDIpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992735AbXDDIpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992748AbXDDIpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:45:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:24539 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992735AbXDDIpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HAJT6p/groo/HDxC/UH884jKJybSR2LRXf0bncYr9vbD1S46TvvZkBkhHveU+/356wLXCQoY5gaOpqxXlKVSPz5n3CddaJBqeDvs7g238zoDUZFSfZrr1SvfF04xHZzcccj0+MdwYzaucwEeNPjAGTVHp7gO+4ieBjup/3uV6V0=
Message-ID: <65258a580704040145m6eb7108frfa8197d3b88e207a@mail.gmail.com>
Date: Wed, 4 Apr 2007 10:45:34 +0200
From: "Vincent Vanackere" <vincent.vanackere@gmail.com>
To: "=?ISO-8859-1?Q?=C9ric_Piel?=" <Eric.Piel@tremplin-utc.net>
Subject: Re: [PATCH] Make ati_remote button repeat sensitivity soft-configurable
Cc: "Karl Pickett" <karl.pickett@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, dmitry.torokhov@gmail.com
In-Reply-To: <461357D8.8060608@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>
	 <461357D8.8060608@tremplin-utc.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/07, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:

> This default value is set to 300 ms. On my Xserver, the default value is
> 660 ms and by default in my distrib it's set to 500 ms. So, indeed, the
> default value of the ati_remote is quite small. Maybe you could increase
> FILTER_MAX to 10 (= 600 ms) in order to have something saner?

Well, this value was chosen because it matches what the hardware does
: as explained in the comments, the hardware generates exactly 5
events for the first keypress (spaced by ~50ms if I recall correctly).

At least on my hardware (=> Vendor=0bc7 ProdID=0004 Rev= 1.00), the
current default value match exactly what I'm expecting (never had the
problem : "if you do anything but barely tap the button you can get
multiple events reported").
Just a thought : perhaps some models are more sensitive than others
(and so the default should be made dependent on the exact remote
model)... what is your hardware id ?

Best regards,

Vincent
