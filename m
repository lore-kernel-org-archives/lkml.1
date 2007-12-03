Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbXLCNMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbXLCNMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXLCNMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:12:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35888 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXLCNMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:12:45 -0500
Subject: Re: [v4l-dvb-maintainer] [PATCH 1/2] ivtv: Some general fixes
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: v4l-dvb-maintainer@linuxtv.org, Richard Knutsson <ricknu-0@student.ltu.se>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200712022049.33601.hverkuil@xs4all.nl>
References: <20071202173329.15374.4223.sendpatchset@thinktank.campus.ltu.se>
	 <200712022049.33601.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Date: Mon, 03 Dec 2007 09:52:08 -0200
Message-Id: <1196682728.6027.47.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Em Dom, 2007-12-02 às 20:49 +0100, Hans Verkuil escreveu:
> On Sunday 02 December 2007 18:46, Richard Knutsson wrote:
> > Fix "warning: Using plain integer as NULL pointer".
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> > Remove a gcc-2.95 requirement.
> 
> NACK! The main v4l-dvb repository that contains this driver can also be 
> compiled on older systems. I'd like to keep the option that the driver 
> can be compiled with an older gcc version, unless Mauro thinks 
> otherwise. Other than the removal of one comment and one space there 
> are no other benefits of this change, so I'd prefer to keep it.

>From my POV, I don't see any reason to remove the required space to keep
gcc-2.95 compatibility. 

The required extra whitespace is a small CodingStyle violation, but may
help to use the same driver code for systems that still use gcc-2.95.
So, it seems valid to keep this whitespace. Besides that, it is properly
commented.
 
Cheers,
Mauro

