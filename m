Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZGOOSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZGOOSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbZGOOSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:18:33 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57833 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZGOOSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G+AHBw5eoz5McHvLesz5biXuMXE+yIZ6uZyoMxS5zjJy4syMI3Ea1bqcrjNFiWh6ph
         JOmXjHL9+droMg5b0wFPaT43CGlUxp2vsk4uxBcFP95RgaptgLSZrxj882d/NgjjhTSs
         jkFKBLPAteFYyJG3PqoH5oaz4+wHWE9DdN5Ms=
Date: Wed, 15 Jul 2009 18:18:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: jens.axboe@oracle.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bio: sizeof pointer instead of size of the pointed-to
	type?
Message-ID: <20090715141828.GC5543@lenovo>
References: <4A5DE10E.7010005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5DE10E.7010005@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Roel Kluin - Wed, Jul 15, 2009 at 04:00:46PM +0200]
|
| Do not take the size of a pointer to determine the size of the pointed-to type
| 
| Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
| ---
| This is not yet tested. Is it correct?
| 

Hi Roel,

as far as I see -- no, it should be not changed at all.
You manage with whole structures not pointers.

	-- Cyrill
