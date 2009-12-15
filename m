Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbZLOSrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbZLOSrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbZLOSre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:47:34 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:47425 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbZLOSrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:47:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=Iwb4fPJD+C3bWGVOCknQwCVEf6olFuft+gBqvJejAg1K/au2v0qGto0mM0QPbzNBod
         NS2rN7cTMQBt4+f3v/kR4hfKHWSIImkA1BvrZTOY93zKs6BNRa1VTnfEhpU7LfoEvgcj
         NgmNycMYXQ+O9eEFPhIpP1ny8MGHrxdvJc8+k=
MIME-Version: 1.0
In-Reply-To: <4B27D302.5060905@gmail.com>
References: <4B27D302.5060905@gmail.com>
From: roel kluin <roel.kluin@gmail.com>
Date: Tue, 15 Dec 2009 19:47:12 +0100
Message-ID: <25e057c00912151047k436058ep2bcff69bdaedcc7a@mail.gmail.com>
Subject: Re: [PATCH] e1000: Fix tests of unsigned in e1000_tx_map()
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 7:18 PM, Roel Kluin <roel.kluin@gmail.com> wrote:
> The variables count and i are unsigned so the (<|>=) 0 tests do not work.

I now see there are similar issues in igb and friends,
I'll post a patch that includes these as well.

Roel
