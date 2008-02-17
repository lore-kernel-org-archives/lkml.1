Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYBQUez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYBQUez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYBQUeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:34:44 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60737 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbYBQUen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:34:43 -0500
Date: Sun, 17 Feb 2008 15:33:49 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Julia Lawall <julia@diku.dk>
Cc: sct@redhat.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/7] fs/ext{2,3,4}: Use BUG_ON
Message-ID: <20080217203349.GH8905@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Julia Lawall <julia@diku.dk>, sct@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0802171854270.28055@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802171854270.28055@ask.diku.dk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 06:55:06PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
> side-effects to allow a definition of BUG_ON that drops the code completely.

Hi, in the future, please separate ext4 changes from ext2/3.  Thanks!!

       	   	   	  	   - Ted
