Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbYDBTLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbYDBTLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbYDBTL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:11:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:19748 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106AbYDBTL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=MS7cBZHds2N/pnOE9Fj8FDDVrZ3IIj+3nkh5yk40KIIPzPt5BP82p2lqa3E0KaOuR7hgKgqzuh2Dv54tVYFT+SmqVrbdpXflh/m8GLONn7hx8F4AWoK7HqCyg7yZ/hFtEx3ur6GjZEuBkb1ey7So9GkC6scTDBV/OoMjrjoCaZg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: [PATCH 1/2] ide: switch /proc/ide/ali to seq_file interface
Date: Wed, 2 Apr 2008 21:20:28 +0200
User-Agent: KMail/1.9.9
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
References: <200804022044.49434.adobriyan@sw.ru>
In-Reply-To: <200804022044.49434.adobriyan@sw.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804022120.28339.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 02 April 2008, Alexey Dobriyan wrote:
> [PATCH 1/2] ide: switch /proc/ide/ali to seq_file interface
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>

Could you please re-do patch #1/2 to remove /proc/ide/ali instead?

[ like we did for all other /proc/ide/<host_driver> files ]

Rationale is that the same can be done from user-space and is not
especially interesting even when debugging problems (raw PCI config
space dump is far more useful).

Thanks,
Bart
