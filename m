Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbZJMKg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbZJMKg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbZJMKg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:36:56 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:45711 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbZJMKgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:36:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=PJOnjPktO9VIKL/a3vKlnVjHCqbJK8fVeBzHArFI1vPHwBS6eNuCBZqV2J9Dmeouoc
         dKkuI40Qbe6lgp//Hnmmbm79DsDsAhc4RDkG0aUzEpn4hFMfBNbq2d1PVqQhStdgNvfu
         YR+P5/rLc5TnFTwSzww9fhkQPr7Tk3ntxGAuk=
MIME-Version: 1.0
In-Reply-To: <20091007061701.GA7567@july>
References: <20091007061701.GA7567@july>
Date: Tue, 13 Oct 2009 13:35:47 +0300
X-Google-Sender-Auth: 3d5c88fe61d08e5c
Message-ID: <359ed6810910130335m45919d6ala921d4cbfa5a341a@mail.gmail.com>
Subject: Re: [PATCH 1/6] Haptic: add haptic class
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       soni.trilok@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 09:17, Kyungmin Park <kyungmin.park@samsung.com> wrote:
> New haptic class support.
> This class handles the haptic devices.

I'm wondering why a haptic class is needed when there is force
feedback support. Admittedly, I don't know the force feedback
implementation too well, but could someone please enlighten me on
this? Am I missing something here?

I see haptics as simple force feedback, just with (usually) small
force and short duration. There are devices out there doing haptics
using vibra motors, which I think would be limited if implemented
using this haptics class driver. Would it be somehow problematic
interfacing with the simple haptic hardware using the force feedback
API?

BR,
Jani.
