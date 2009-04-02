Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZDBLZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZDBLZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZDBLZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:25:20 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:41833 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZDBLZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:25:19 -0400
Date: Thu, 2 Apr 2009 12:25:07 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090402112507.GA24532@sucs.org>
References: <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <2c0942db0904011421w58c0c2dyb70235fb739cbd30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0904011421w58c0c2dyb70235fb739cbd30@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 02:21:43PM -0700, Ray Lee wrote:
> 
> Some guy named Andrew used to run a kernel with 'return 0' at the top
> of fsync and fdatasync: http://lkml.org/lkml/2007/4/27/88

(Quoting out of context from Andrew's mail)

"hm, fsync.

Aside: why the heck do applications think that their data is so
important that they need to fsync it all the time."

So the advice/complaint is that apps shouldn't fsync unless absolutely
necessary because syncing will always slow?

-- 
Sitsofe | http://sucs.org/~sits/
