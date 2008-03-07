Return-Path: <linux-kernel-owner+w=401wt.eu-S1764194AbYCGMnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764194AbYCGMnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 07:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763013AbYCGMmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 07:42:49 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40033 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913AbYCGMms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 07:42:48 -0500
Subject: Re: [PATCH][v2] Modify loop device to be able to manage partitions
	of the disk image
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Andreas Schwab <schwab@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <jepru6n283.fsf@sykes.suse.de>
References: <12048928601734-git-send-email-Laurent.Vivier@bull.net>
	 <jepru6n283.fsf@sykes.suse.de>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Fri, 07 Mar 2008 13:45:09 +0100
Message-Id: <1204893909.4315.32.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le vendredi 07 mars 2008 à 13:33 +0100, Andreas Schwab a écrit :
> Laurent Vivier <Laurent.Vivier@bull.net> writes:
> 
> > +static int __init max_part_setup(char *str)
> > +{
> > +	loop_max_part = simple_strtol(str, NULL, 0);
> > +	if (loop_max_part > (1UL << (MINORBITS - 1))) {
> > +		/* we must keep at least one bit for loop device number */
> > +		printk(KERN_ERR
> > +			"loop: loop_max_part cannot be greater than %d\n",
> > +			1UL << (MINORBITS - 1));
> 
> Since the argument is of type unsigned long you should use %ld or %lu.

Yes, I wait for some more comments and I will re-send a [v3].

Laurent
-- 
----------------- Laurent.Vivier@bull.net  ------------------
"Programmers who subconsciously view themselves as artists
 will enjoy what they do and will do it better." D. Knuth

