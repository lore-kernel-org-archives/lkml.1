Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYE1RHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYE1RHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYE1RGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:06:54 -0400
Received: from atlantis.cc.ndsu.NoDak.edu ([134.129.99.37]:58552 "EHLO
	atlantis.cc.ndsu.NoDak.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766AbYE1RGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:06:54 -0400
X-Greylist: delayed 1234 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2008 13:06:54 EDT
Date: Wed, 28 May 2008 11:46:16 -0500
From: Bryan Mesich <bryan.mesich@ndsu.edu>
To: Jens =?iso-8859-1?Q?B=E4ckman?= <jens.backman@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Message-ID: <20080528164616.GB29722@atlantis.cc.ndsu.NoDak.edu>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mail-Followup-To: Bryan Mesich <bryan.mesich@ndsu.edu>,
	Jens =?iso-8859-1?Q?B=E4ckman?= <jens.backman@gmail.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	xfs@oss.sgi.com
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
X-Operating-System: Fedora Release 8
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 06:34:00PM +0200, Jens Bäckman wrote:

> Either the RAID 1 read speed must be wrong, or something is odd in the
> Linux implementation. There's six drives that can be used for reading
> at the same time, as they contain the very same data. 63MB/s
> sequential looks like what you would get from a single drive.

The RAID 1 read speed metrics do not depict multithreaded
processes reading from the array simutaneouly. I would suspect
that the read performance metrics would look better if 2 bonnie
simulations were ran together (for RAID 1 that is).

Bryan 
