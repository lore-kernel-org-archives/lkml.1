Return-Path: <linux-kernel-owner+w=401wt.eu-S932514AbZACBTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbZACBTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 20:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758334AbZACBTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 20:19:31 -0500
Received: from phunq.net ([64.81.85.152]:38660 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758321AbZACBTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 20:19:30 -0500
From: Daniel Phillips <phillips@phunq.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Date: Fri, 2 Jan 2009 17:19:26 -0800
User-Agent: KMail/1.9.5
Cc: tux3@tux3.org, Martin Steigerwald <Martin@lichtvoll.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200812301935.49303.phillips@phunq.net> <200901021445.37062.phillips@phunq.net> <495E9F22.3080206@gmail.com>
In-Reply-To: <495E9F22.3080206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901021719.26680.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2009 15:11, Justin P. Mattock wrote:
> The game that came to mind when I first
> heard of tux3(I had to google a bit to find the name)
> was tux racer.  :^)
> quick question:
> what is the state for security file labeling for
> SELinux on this filesystem?

There is a lot of interest in security labels.  You are not the first
to ask.

Tux3 variable inode attributes are ideal for implementing security 
labels efficiently, way more lightweight than extended attributes.  
Otherwise, we would like to know exactly what people want.

Regards,

Daniel

