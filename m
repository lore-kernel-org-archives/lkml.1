Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbZBYBot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbZBYBot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZBYBok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:44:40 -0500
Received: from outbound-mail-128.bluehost.com ([67.222.38.28]:56167 "HELO
	outbound-mail-128.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751856AbZBYBok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:44:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=pjxIoJrp5PUgBv80MTzhQajWekodTvJqcRqwKErw5CVWiswoBeoHtAvwxm0erzoZb7bRiQvsW75dkKpklPCe1lYUw8O9JAqiZBjjZ9setxEGaefDv1A5gOe8GHSudi+0;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kyle McMartin <kyle@infradead.org>
Subject: Re: [PATCH] drm: edid revision 0 is valid
Date: Tue, 24 Feb 2009 17:44:30 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: airlied@redhat.com, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, marko.ristola@kolumbus.fi
References: <20090225013153.GC6690@bombadil.infradead.org>
In-Reply-To: <20090225013153.GC6690@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241744.30556.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 24, 2009 5:31:53 pm Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
>
> edid->revision == 0 should be valid (at least, so the error message
> indicates. :) and wikipedia seems to indicate that EDID 1.0 existed.
>
> We can dump the entire check, since edid->revision is a u8, so
> it can't ever be less than 0.
>
> Marko reports in RH bz#476735 that his monitor claims to be
> EDID 1.0, and therefore hits the check and is stuck at 800x600 because
> of it.
>
> Reported-by: Marko Ristola <marko.ristola@kolumbus.fi>
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Heh, yeah this makes the code correct *and* match the message.  Thanks.

Acked-by: Jesse Barnes <jbarnes@virtuousgek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
