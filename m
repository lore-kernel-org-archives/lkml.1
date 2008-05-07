Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYEGH7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYEGH7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYEGH67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:58:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:26496 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYEGH66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:58:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NmWf41SQzHiNNRQk+pZ6pS9wrKFyrKTp93age1TKE0qX54fQEraLqEJ+qqNmb1mg5g3L5tiDQBb0otpj3apYZrBzRb38I7t2M+TvWJTyfCwGZlycPpwiG62zQc4g+feliS7ad+e1zeyiP3/x8Lmd7P+cQUjtHb4o3IFhn/0OmEw=
Message-ID: <e2e108260805070058p476901f5ta4c38e99e1421eec@mail.gmail.com>
Date: Wed, 7 May 2008 09:58:56 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Tomasz Chmielewski" <mangoo@wpkg.org>
Subject: Re: Compact Flash Question
Cc: LKML <linux-kernel@vger.kernel.org>, YSadgat1@gcte.com,
       linux-os@analogic.com, Alan <alan@lxorguk.ukuu.org.uk>,
       "Linux IDE" <linux-ide@vger.kernel.org>
In-Reply-To: <48216039.3070001@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48215673.3060201@wpkg.org>
	 <e2e108260805070044v42f596bbj39c5b52b6f0a096@mail.gmail.com>
	 <48216039.3070001@wpkg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 9:54 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> How does it work, then?
> How can it do wear levelling over the whole CF if some (or most) area of CF
> is already used by our precious data/metadata?
> It would have to know the areas where no data is stored, but it contradicts
> the CF <-> filesystem separation.

The wear leveling algorithm even works if the CompactFlash controller
has no knowledge of the sectors on which filesystem data is stored.
All that is needed is some spare space on the CompactFlash that is not
made visible through the IDE interface, a controller that is able to
remap sectors and that stores this mapping persistently.

Bart.
