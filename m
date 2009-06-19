Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZFSUfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZFSUfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbZFSUf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:35:26 -0400
Received: from senator.holtmann.net ([87.106.208.187]:34153 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbZFSUfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:35:25 -0400
Subject: Re: Trivial fixes for drivers/gpu/drm/i915/
From: Marcel Holtmann <marcel@holtmann.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Dave Airlie <airlied@linux.ie>, Keith Packard <keithp@keithp.com>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
In-Reply-To: <m34ouc55ka.fsf@intrepid.localdomain>
References: <m34ouc55ka.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 22:35:18 +0200
Message-Id: <1245443718.15367.46.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

> size_t is (some sort of) int on x86-32 and long on x86-64, eliminate
> compiler warnings by casting to long.

just using %zd or %zu would do the same trick and avoid stupid casts.

Regards

Marcel


