Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbYEEO0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbYEEO0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYEEO0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:26:13 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36352 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756341AbYEEO0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:26:12 -0400
Subject: Re: [PATCH] Fusion MPT: Convert inactive_list_mutex in a mutex
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Eric.Moore@lsi.com, support@lsi.com, DL-MPTFusionLinux@lsi.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080504180544.GN20036@traven>
References: <20080504180544.GN20036@traven>
Content-Type: text/plain
Date: Mon, 05 May 2008 09:26:06 -0500
Message-Id: <1209997566.3163.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-04 at 20:05 +0200, Matthias Kaehlcke wrote:
> MPT Fusion: The semaphore inactive_list_mutex is used as a
> mutex. Convert it to the mutex API
> 
> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Um, it would at least vaguely help if you checked the tree; even
actually trying to apply the patch would have told you.  I know the
email notifications from scsi misc can sometimes get lost.

commit ed5f606fef22e515331aab4c1f927775cf4af70e
Author: Matthias Kaehlcke <matthias@kaehlcke.net>
Date:   Sun Mar 9 12:16:27 2008 +0100

    [SCSI] mpt fusion: convert inactive_list_mutex to a mutex

James


