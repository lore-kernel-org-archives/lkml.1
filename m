Return-Path: <linux-kernel-owner+w=401wt.eu-S1762472AbYESSkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762472AbYESSkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760387AbYESSjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:39:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:36792 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758007AbYESSje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:39:34 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: recent 2.6.26 kernel hangs at suspend
Date: Mon, 19 May 2008 14:38:52 -0400
User-Agent: KMail/1.9.9
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, len.brown@intel.com,
       "Shaohua Li" <shaohua.li@intel.com>, "Greg KH" <greg@kroah.com>
References: <b6a2187b0805190807o7f6e87e1nd883607d603c893b@mail.gmail.com>
In-Reply-To: <b6a2187b0805190807o7f6e87e1nd883607d603c893b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191438.53323.lenb@kernel.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [140.211.167.34]); Mon, 19 May 2008 18:39:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008, Jeff Chua wrote:
> I can simulate this and it's definitely a bug, but I could only bisect
> up to a point and the kernel would not boot after tat.
> 
> The bug is that my X60s notebook would not suspend-to-ram on the 2nd try.
>
> Boot up -> suspend to ram -> ok -> resume -> suspend to ram -> hang!
> 
> The hang would only happen while in X.

Does this notebook have intel graphics?
If yes, does anything change with the i915 driver loaded vs not loaded?

-Len
