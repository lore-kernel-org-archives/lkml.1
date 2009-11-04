Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbZKDTT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbZKDTT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbZKDTTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:19:55 -0500
Received: from outbound-mail-116.bluehost.com ([69.89.22.16]:51383 "HELO
	outbound-mail-116.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755277AbZKDTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:19:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FEHtAOZuE8oR64jVRKNpZFTTOMHUFgP8qwBvEVInkoc8Qr7e34/NfH+nNVZVmSn1QmOrSA4hDlFPa+5pC05Yu/j5wypZHZHt5qXFwojePJe2BtqYDOlnn3PR4lNu3Jwv;
Date: Wed, 4 Nov 2009 11:19:58 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
Subject: Re: no video output after suspend after "drm/i915: force mode set
 at lid open time"
Message-ID: <20091104111958.1b9c738e@jbarnes-piketon>
In-Reply-To: <4AEC3FC3.3090209@gmail.com>
References: <4AE4BBBC.2070809@gmail.com>
	<20091026090548.2d4e20a9@jbarnes-g45>
	<4AE76463.6010404@gmail.com>
	<20091027142609.73ac95e2@jbarnes-g45>
	<4AEC3ED7.6010003@gmail.com>
	<4AEC3FC3.3090209@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009 14:46:43 +0100
Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:
> > Sorry for taking so long to respond. Anyway latest Linus' git
> > master with reverted c1c7af60892070e4b82ad63bbfb95ae745056de0 , per
> > attached patch, does not fix the issue for me. Please note that
> > just reverting the commit does not compile because of an added user
> > of acpi_lid_open() which requires acpi/button.h which has been
> > added in 7121413f2accf14cf05b38539fb7a8be77543370. Will try to
> > revert that too.
> 
> Sorry, that commit just change that line, it does not add the 
> acpi_lid_open() call.

Linus's tree has another change which might help:

commit c9354c85c1c7bac788ce57d3c17f2016c1c45b1d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Nov 2 09:29:55 2009 -0800

    i915: fix intel graphics suspend breakage due to resume/lid event
    confusion

Have you tried a tree with it included yet?

-- 
Jesse Barnes, Intel Open Source Technology Center
