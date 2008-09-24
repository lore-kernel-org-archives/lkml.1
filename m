Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYIXKa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYIXKa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYIXKat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:30:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53921 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYIXKat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:30:49 -0400
Date: Wed, 24 Sep 2008 11:30:40 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?iso-8859-1?Q?S=F8ren?= Hauberg <hauberg@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       Ondrej Zary <linux@rainbow-software.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] usbtouchscreen, 2.6.25
Message-ID: <20080924103040.GA13392@srcf.ucam.org>
References: <ed7dcf450809230142l62bb00aapb92e6cb225f0cbba@mail.gmail.com> <200809231051.14016.linux@rainbow-software.org> <ed7dcf450809230236v762e0aa3v8748c76a64121f0c@mail.gmail.com> <200809231613.41905.oliver@neukum.org> <ed7dcf450809240004r1d3c7b3ds619cd7441ae0365e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed7dcf450809240004r1d3c7b3ds619cd7441ae0365e@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:04:55AM +0200, Søren Hauberg wrote:
> Obviously that depends on how you define "better" :-) The problem I'm
> facing is that with the X driver there is no way to change calibration
> without restarting X several times, which isn't acceptable for the
> application we're developing. Sure, I could fix the X driver to allow
> run-time changes to the calibration parameters, but that's a very
> large task. 

This is the sort of thing that input device properties were added for. 
If you're able to use 1.5 of the X server, it's not a huge body of work 
to add this functionality.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
