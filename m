Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbXLET4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbXLET4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbXLET4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:56:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36958 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbXLET4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:56:41 -0500
Date: Wed, 5 Dec 2007 20:56:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Anderson <anderson@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: allow > 2GB executables to run on 64-bit systems
Message-ID: <20071205195637.GA20595@one.firstfloor.org>
References: <4756C590.9080301@redhat.com> <p73fxyhj5f7.fsf@bingen.suse.de> <475702E7.1000607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475702E7.1000607@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree in theory.  We've only seen instances on 64-bitters...

I think that's because gcc does not support the medium/large code models
for i386. Although in theory someone could create an executable with
a large enough .data.

-Andi
