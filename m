Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZBGIHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZBGIHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 03:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZBGIG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 03:06:59 -0500
Received: from smtp2f.orange.fr ([80.12.242.150]:24923 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbZBGIG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 03:06:59 -0500
X-ME-UUID: 20090207080656809.C57F37000083@mwinf2f04.orange.fr
Subject: Re: Gem GTT mmaps..
From: Xavier Bestel <xavier.bestel@free.fr>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>,
       Eric Anholt <eric@anholt.net>, DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200902061424.02906.jbarnes@virtuousgeek.org>
References: <498A1760.7010108@shipmail.org>
	 <200902060914.59956.jbarnes@virtuousgeek.org>
	 <498CAD2F.5070806@shipmail.org>
	 <200902061424.02906.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Feb 2009 09:06:34 +0100
Message-Id: <1233993994.5537.5.camel@badjo>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 06 février 2009 à 14:24 -0800, Jesse Barnes a écrit :
> +       map = list->map;
> +       if (map) {
> +               drm_free(map, sizeof(*map), DRM_MEM_DRIVER);
> +               list->map = NULL;

I would have inverted the two last lines (otherwise why wouldn't you
directly drw_free(list->map) ?).

	Xav


