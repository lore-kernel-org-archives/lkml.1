Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbXE3X26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbXE3X26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbXE3X2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:28:50 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:7504 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbXE3X2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fVThO7gwrJ1gamM0BExB+gmDsQVf+FFkiPaUgrzLj0hB0Z+fxpams2e8C1WRxZBbBik+2xa0tClBilhmlAiP9VCPRhHPvwclYjgA6WZ8eLF2bWFEJOf1eEYiL+eAuLg5ZUluYgGrPq4fFFP+WjDZFQPaiDW7na2e669IE6kFjZs=
Subject: Re: tty-related oops in latest kernel(s)?
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: adobriyan@gmail.com, akpm@linux-foundation.org, teanropo@jyu.fi,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, apw@shadowen.org,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <20070530.161811.108115564.davem@davemloft.net>
References: <20070530090945.ab9d51d9.akpm@linux-foundation.org>
	 <20070530180428.GA5731@martell.zuzino.mipt.ru>
	 <1180566886.4570.14.camel@daplas>
	 <20070530.161811.108115564.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 31 May 2007 07:28:42 +0800
Message-Id: <1180567722.4570.22.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 16:18 -0700, David Miller wrote:
> From: "Antonino A. Daplas" <adaplas@gmail.com>
> Date: Thu, 31 May 2007 07:14:46 +0800
> 
> > Yes, 256 is too many. the pseudo_palette is used for the 16-color
> > console only.
> 
> Many many drivers allocate 256 entries, just FYI :-)  They
> all should be fixed up I guess.

I did a pseudo_palette allocation audit before, it might be high time to
run one again :-(

Tony

