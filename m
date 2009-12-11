Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZLKDjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZLKDjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZLKDjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:39:24 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:36312 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753074AbZLKDjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:39:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=j4bQfyAFEmsxdyzEBVSl6SjcMxMPAM1inQ3jbPaOcCAD7evLsLT1ADxtAeNLYlOuQcRNjoWY3ZvtdVLV7AYdo47iiqyfhCjip4WRHwCO0uUh8yYISmiD/XzvR6gYKAKr+2FXw+Ei5Lu7cFgkpO9m/wEVVWzGODE8BBR74cT1pDQ=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: eP7y90YVM1moog2Sf5vnPlD37N4v33qecoQNpHEgVFfOU_Sgg_q0nX30._y._DKeAdgNSb34mbzZDAZ99GMHrgTthOS40PxKorMBqqvUR3F0OLWCEZqivX9YBO4jBc9O4uc8f1QvzAoZIuHDblpyhqzVe6OwvW4kzQESTx6gMb1gBXGeQf3TOZ5eRf.mewXJx_uZQZ4ms4thCbbAXOo3FMWQboPWu2pdTN2QaeJbNZmr8rbI6rb3hJ0MJPBpBR4G
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use gpioN for device names
Date: Thu, 10 Dec 2009 19:39:30 -0800
User-Agent: KMail/1.9.10
Cc: dbrownell@users.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org, dsilvers@simtec.co.uk, ben@simtec.co.uk,
       Artem.Bityutskiy@nokia.com, akpm@linux-foundation.org
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com> <8859db84eb13c0056e20c5edd5dba6837cb60c27.1260364108.git.ext-jani.1.nikula@nokia.com>
In-Reply-To: <8859db84eb13c0056e20c5edd5dba6837cb60c27.1260364108.git.ext-jani.1.nikula@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912101939.30446.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 December 2009, Jani Nikula wrote:
> While the device names are now unique again, collisions in chip->names
> will still prevent duplicates from being exported to sysfs.

That's why I was never a real fan of chip->names...

IMO a "good" solution in this space needs to accept that
those names are not going to be globally unique ... but
that they'll be unique within some context, of necessity.

If Greg doesn't want to see those names under classes,
so be it ... but where should they then appear?

- Dave
