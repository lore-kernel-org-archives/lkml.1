Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbZAHAX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbZAHAX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 19:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZAHAXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 19:23:19 -0500
Received: from adelie.canonical.com ([91.189.90.139]:57176 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbZAHAXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 19:23:18 -0500
Date: Thu, 8 Jan 2009 00:23:17 +0000
From: Andy Whitcroft <apw@canonical.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: confusing checkpatch.pl messages
Message-ID: <20090108002317.GA13284@shadowen.org>
References: <4963C5C0.2080304@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4963C5C0.2080304@freemail.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 09:57:36PM +0100, Németh Márton wrote:
> Hi,
> 
> I run the checkpatch.pl against the attache file and it reported some
> confusing warning and error messages. The attached file has an obsoleted
> syntax:
[...]
> >     struct point p = { y: yvalue, x: xvalue };
> 
> However, the checkpatch.pl speaks about labels, which are incorrect, I think:

Yeah that is the wrong error for sure.  Will see if I can stop it doing
that and emit something more sensible.

-apw
