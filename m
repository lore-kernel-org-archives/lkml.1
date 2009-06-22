Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZFVX1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZFVX1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZFVX1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:27:41 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38762 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbZFVX1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:27:41 -0400
Subject: Re: Regression: ppc powerstation boot hang caused by slab
 initialisation code
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1245711062.4017.1.camel@pasglop>
References: <1245708635.17035.6.camel@mulgrave.site>
	 <1245709633.20062.13.camel@pasglop>
	 <1245710457.17035.9.camel@mulgrave.site>  <1245711062.4017.1.camel@pasglop>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 18:21:32 -0500
Message-Id: <1245712892.17035.39.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 08:51 +1000, Benjamin Herrenschmidt wrote:
> Ah, I notice you use SLAB, that's the second report of hangs with it due to
> the changes. You can try SLUB while I'm looking, might help.

Yes, switching to slub fixes it ... although given that the identified
problem commit is a slab one, that's understandable ...

James


