Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbZDRVFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbZDRVFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 17:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbZDRVFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 17:05:45 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:53611 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbZDRVFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 17:05:45 -0400
Date: Sat, 18 Apr 2009 23:06:38 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: [console] CSI (128+27) vs BIG5 (and possibly others)
Message-ID: <20090418210638.GU21409@const>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A chinese user reported that some characters don't show up fine on
its console.  This happens to be because character 128+27 is handled
specially by the linux Console.  I believe the same issues can happen
with other characters sets.  Since linux' terminfo makes applications
use \E[ anyway, would it be ok to add an option to disable the 128+27
handling?

Samuel
