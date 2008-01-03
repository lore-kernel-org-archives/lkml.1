Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYACTzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYACTzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 14:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYACTzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 14:55:44 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:56332 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYACTzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 14:55:44 -0500
Date: Thu, 3 Jan 2008 20:55:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC 1/3] Change CONFIG_LOCALVERSION_AUTO to use a git-describe-ish format
Message-ID: <20080103195534.GC21227@uranus.ravnborg.org>
References: <1194054781-16609-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194054781-16609-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 09:52:59PM -0400, Theodore Ts'o wrote:
> Change the automatic local version to have the form -nnnnn-gSHA1SUMID,
> where 'nnnnn' is the number of commits since the last tag (i.e.,
> 2.6.21-rc7).  This makes it much more likely that the package names created
> for the kernel will look "newer" to a package manager.

Applied all three. Removed the dash in git describe to make in conformant
to versions of git without it.

	Sam
