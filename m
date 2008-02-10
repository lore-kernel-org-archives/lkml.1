Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYBJKsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYBJKsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbYBJKsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:48:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:52310 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354AbYBJKsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:48:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=O1jPKELGdPCczQYtNMGpaUiNIypfJiDmHdhwedEr7X3t1JvY/SjsxRMWjr/9dNIpog3ap2XEeOIia++/ZdKnC+ydJkdKiMnUzeboYTLDTkmljyML05o5mvwKzzxlEnOHr2uOULUfWmC+b3B4ZPIFzjASAcwmfgwUoUoAR5cpYck=
Date: Sun, 10 Feb 2008 11:48:17 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: udf regression: broken directory handling
Message-ID: <20080210104754.GH6737@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Current mainline has a problem with reading file list.
Simple ls prints only 2 out of 8 files on my testing DVD.
Reverting your patch "udf: cleanup directory offset handling"
(af793295bf9ee92660f5e77d337b0493cea3f9b9) fixes the problem.

Marcin
