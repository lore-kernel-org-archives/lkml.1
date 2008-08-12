Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbYHLJnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbYHLJnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 05:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYHLJne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 05:43:34 -0400
Received: from anguilla.debian.or.at ([86.59.118.152]:37100 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYHLJne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 05:43:34 -0400
Date: Tue, 12 Aug 2008 11:43:32 +0200
From: Peter Palfrader <peter@palfrader.org>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.26.1 hangs on dl385
Message-ID: <20080812094332.GD17095@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	linux-kernel@vger.kernel.org
References: <20080806123301.GJ25710@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080806123301.GJ25710@anguilla.noreply.org>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008, Peter Palfrader wrote:

> Every single one of them died within at most a few days, sometimes even
> within minutes.

On Mon, Aug 11, 2008 at 11:17:34PM -0600, dann frazier wrote:
|  This is readily reproducible - a simple kernel compile was all it
| took. git bisecting suggests that this issue was introduced by [1]
| and unmasked by [2] during 2.6.26 devlopment. It was later fixed
| during 2.6.27 development by [3].
| 
| [1] 35605a1027ac630f85a1b95684f7e86b82498cd6
| [2] 8d539108560ec121d59eee05160236488266221c
| [3] 8004dd965b13b01a96def054d420f6df7ff22d53

See http://bugs.debian.org/494365 for details.

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
