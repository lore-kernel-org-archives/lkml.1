Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZFWRnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZFWRnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZFWRne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:43:34 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:48885 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752099AbZFWRnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:43:33 -0400
Date: Tue, 23 Jun 2009 13:43:26 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       hugh.dickins@tiscali.co.uk
Subject: Re: Why half of slabs are not shown in /proc/slabinfo?
In-Reply-To: <1245653782.18751.12.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906231342560.11807@gentwo.org>
References: <200906211152.25100.arvidjaar@mail.ru>  <84144f020906210426h6a41ad3csf6d9731663e30834@mail.gmail.com>  <200906211530.13463.arvidjaar@mail.ru> <1245653782.18751.12.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Pekka Enberg wrote:

> If you exclude all the symbolic links, the number of caches matches. As
> Hugh already explained, SLUB merges caches which shows up like this in
> the sysfs directory.

And if you enable full debugging by booting with "slub_debug" then they
will be separate again.

