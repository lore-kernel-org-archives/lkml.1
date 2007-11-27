Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbXK0VKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbXK0VKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbXK0VK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:10:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:43798 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbXK0VKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:10:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C6RjVsJ53pXFMnulnhZeJ9zae6J5XRoflKXuovjc2lZR/yqkwL+fVWFFKpiwKhSb6vxVjU9R+FNax2+yzriyqX6jc4SYHTgCDzqiXlXCmnJRFZ89MwAscggxfhkP7N965XdEdyRkRfhC1cqaUQrv6+IwK8tWUoQdpXMTUHKo/Zk=
Message-ID: <ed5aea430711271310i144c005cj25101b7dd6b0d6d9@mail.gmail.com>
Date: Tue, 27 Nov 2007 14:10:21 -0700
From: "David Mosberger-Tang" <dmosberger@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for per cpu access
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
In-Reply-To: <Pine.LNX.4.64.0711271014550.2310@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071127001407.859743255@sgi.com>
	 <20071127001430.083503280@sgi.com>
	 <ed5aea430711262120p45bb5b2t1b16872e74547369@mail.gmail.com>
	 <Pine.LNX.4.64.0711271014550.2310@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Mon, 26 Nov 2007, David Mosberger-Tang wrote:
>
> > On 11/26/07, Christoph Lameter <clameter@sgi.com> wrote:
> > > The model(small) attribute is not supported by gcc 4.X. The tests
> > > will always be negative today.
> >
> > What was the rationale for removing this attribute?
>
> The code is then similar across all architectures and can be moved into
> generic code.

Uniformity for the sake of uniformity?  The small data addressing is
really elegant and I don't think it should be dropped just for the
sake of uniformity.

  --david
