Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYAHKlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYAHKlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYAHKlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:41:13 -0500
Received: from ozlabs.org ([203.10.76.45]:57977 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbYAHKlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:41:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: [PATCH 4/4] Fixup container_of() usage
Date: Tue, 8 Jan 2008 21:40:51 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
References: <20080108084629.GD6209@localhost.sw.ru>
In-Reply-To: <20080108084629.GD6209@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801082140.52018.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 19:46:29 Alexey Dobriyan wrote:
> Using "attr" twice is not OK, because it effectively prohibits such
> container_of() on variables not named "attr".
>
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

Thanks, nice catch.  Took me a while to understand that you meant "you can't 
use to_sq_sysfs_attr() on a variable not named attr".

Acked-by: Rusty Russell <rusty@rustcorp.com.au>
