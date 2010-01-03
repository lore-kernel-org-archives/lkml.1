Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984Ab0ACQ5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0ACQ5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 11:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956Ab0ACQ5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 11:57:11 -0500
Received: from isilmar.linta.de ([213.133.102.198]:39673 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751805Ab0ACQ5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 11:57:09 -0500
Date: Sun, 3 Jan 2010 17:30:52 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/2] resource: align functions now return start of
 resource
Message-ID: <20100103163052.GA5282@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
	torvalds@linux-foundation.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20100101163811.GA8124@comet.dominikbrodowski.net>
 <1262364050-8540-1-git-send-email-linux@dominikbrodowski.net>
 <86802c441001011412u1543c1afk6337cd6d3ea0f257@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c441001011412u1543c1afk6337cd6d3ea0f257@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Jan 01, 2010 at 02:12:09PM -0800, Yinghai Lu wrote:
> > -                       res->start = start;
> > -               }
> > -       }
> > +       if ((res->flags & IORESOURCE_IO) && (start & 0x300))
> > +               start = (start + 0x3ff) & ~0x3ff;
> > +
> > +       return start
> 
> missed ; here?

Indeed -- thanks for the hint.

Best,
	Dominik
