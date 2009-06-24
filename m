Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZFXHzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZFXHzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZFXHz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:55:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52476 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZFXHz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:55:28 -0400
Date: Wed, 24 Jun 2009 09:55:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Len Brown <lenb@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] SFI: core support
Message-ID: <20090624075531.GM6760@one.firstfloor.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org> <8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com> <87iqin166f.fsf@basil.nowhere.org> <20090624113440.2774d13d@feng-desktop> <20090624071220.GJ6760@one.firstfloor.org> <20090624154052.1301144f@feng-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624154052.1301144f@feng-desktop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> understand your concern, but to walk a list we still need have some global
> parameter like SYST address, and do the map/unmap and checksum work.

You just keep it mapped always. And the checksums only need to 
be checked once at the beginning. If there's a checksum error
anywhere it's better to complete disable SFI

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
