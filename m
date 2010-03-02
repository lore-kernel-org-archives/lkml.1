Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab0CBJaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:30:24 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:65210 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0CBJaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:30:21 -0500
Date: Tue, 2 Mar 2010 01:29:47 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: James Morris <jmorris@namei.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>, Mark Fasheh <mfasheh@suse.com>,
       Alex Elder <aelder@sgi.com>, Chris Mason <chris.mason@oracle.com>,
       a.gruenbacher@computer.org
Subject: Re: [PATCH 2/2] ocfs2: ensure trusted xattrs are not returned to
 unprivileged users via listxattr
Message-ID: <20100302092946.GA21180@mail.oracle.com>
Mail-Followup-To: James Morris <jmorris@namei.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Mark Fasheh <mfasheh@suse.com>, Alex Elder <aelder@sgi.com>,
	Chris Mason <chris.mason@oracle.com>, a.gruenbacher@computer.org
References: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org>
 <alpine.LRH.2.00.1003021901530.1594@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1003021901530.1594@tundra.namei.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B8CDA9D.0058:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 07:02:22PM +1100, James Morris wrote:
> Ensure that trusted xattrs are not returned to unprivileged users
> via listxattr, in keeping with several other implmentations, such
> as ext3.
> 
> Signed-off-by: James Morris <jmorris@namei.org>

If this is the standard expectation, why not lift it up into the vfs?

Acked-by: Joel Becker <joel.becker@oracle.com>

-- 

"The nearest approach to immortality on Earth is a government
 bureau."
	- James F. Byrnes

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
