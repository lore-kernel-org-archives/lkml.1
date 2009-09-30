Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZI3X1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZI3X1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZI3X1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:27:23 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:58106 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbZI3X1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OO0s81TcahnPe/IMIIXDMGx/gCQweJxCIgkcsViVL8M10puCeW+/Clb/fVoJEuyyW9
         V5cbu+8aeTRxwD4bbIwl71/H3uqqlsqXznkWzHRRrOlGLdKq7mLeD1iUhWbuw5FtNrta
         iS2/hwHMLVceXkGPq+BnYVX/IIS8on+8BBnzs=
MIME-Version: 1.0
In-Reply-To: <1254227539-8306-1-git-send-email-jglisse@redhat.com>
References: <1254227539-8306-1-git-send-email-jglisse@redhat.com>
Date: Thu, 1 Oct 2009 09:27:26 +1000
Message-ID: <21d7e9970909301627q4ee123c2gb685c7f64fb3294f@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon/kms: Convert RS690/RS740 to new init path.
From: Dave Airlie <airlied@gmail.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 10:32 PM, Jerome Glisse <jglisse@redhat.com> wrote:
> Also cleanup register specific to RS690/RS740.
>
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  drivers/gpu/drm/radeon/radeon.h      |   10 +
>  drivers/gpu/drm/radeon/radeon_asic.h |   41 ++--
>  drivers/gpu/drm/radeon/rs600.c       |    7 +-
>  drivers/gpu/drm/radeon/rs690.c       |  358 +++++++++++++++++++++------------
>  drivers/gpu/drm/radeon/rs690r.h      |   99 ----------
>  5 files changed, 266 insertions(+), 249 deletions(-)
>  delete mode 100644 drivers/gpu/drm/radeon/rs690r.h

This forgets to add rs690d.h here so breaks the build.

Dave.
