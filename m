Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbYAQLVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbYAQLVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 06:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYAQLVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 06:21:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:43088 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYAQLVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 06:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JxjRWs+Y2g/E9mCGHfnNxgDFt/mc8WjzTiEsv/EuzhdLiI49c20HJ6M3cHFXmXFG/ukj5lsI82489LlUMdU14cWMEW7lF57JLrOflPl7w04yATQAusIH51uBtxODa+gwXMtJL2ihPaufXYlm2VDl0+VR3twYi48H2UIFtcnQ6wg=
Message-ID: <84144f020801170321s37275632j4d05fe96672907c9@mail.gmail.com>
Date: Thu, 17 Jan 2008 13:21:20 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: CaT <cat@zip.com.au>
Subject: Re: 2.6.24-rc7: memory leak?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080117063410.GQ3940@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080117063410.GQ3940@zip.com.au>
X-Google-Sender-Auth: b658c3d5c58286aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 17, 2008 8:34 AM, CaT <cat@zip.com.au> wrote:
> There are 75 processes on the box of which almost 47 are kernel
> processes + init. Of the rest, the top 3 have an RSS of 9.4meg, 6.2meg
> and 4.8meg, 7 are at around 2meg and the rest are below 2meg with the
> majority below 1. So unless I'm misunderstanding something, processess
> alone do not account for the amount of used memory.

Looking at /proc/slabinfo, 965 MB is used by the ext3 inode cache and
144 MB by the dentry cache.

                              Pekka
