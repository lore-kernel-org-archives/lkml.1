Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXLIOFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXLIOFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 09:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbXLIOFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 09:05:44 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:46273 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751459AbXLIOFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 09:05:43 -0500
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: Pardus / KDE
To: Theodore Tso <tytso@mit.edu>, Adrian Bunk <bunk@kernel.org>,
       Bill Davidsen <davidsen@tmr.com>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Date: Sun, 9 Dec 2007 16:06:49 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
References: <20071204114125.GA17310@torres.zugschlus.de> <200712090821.16483.ismail@pardus.org.tr> <20071209123147.GZ17037@thunk.org>
In-Reply-To: <20071209123147.GZ17037@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712091606.50089.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday 09 December 2007 14:31:47 tarihinde Theodore Tso şunları yazmıştı:
> On Sun, Dec 09, 2007 at 08:21:16AM +0200, Ismail Dönmez wrote:
> > My understanding was if you can drain entropy from /dev/urandom any
> > futher reads from /dev/urandom will result in data which is not random at
> > all. Is that wrong?
>
> Past a certain point /dev/urandom will stat returning results which
> are cryptographically random.  At that point, you are depending on the
> strength of the SHA hash algorithm, and actually being able to not
> just to find hash collisions, but being able to trivially find all or
> most possible pre-images for a particular SHA hash algorithm.  If that
> were to happen, it's highly likely that all digital signatures and
> openssh would be totally broken.

Thats very good news, thanks for the detailed explanation. Time to update 
common misconceptions.

Regards,
ismail

-- 
Never learn by your mistakes, if you do you may never dare to try again.
