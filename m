Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbYDJU7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbYDJU7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYDJU7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:59:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49080 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245AbYDJU7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:59:22 -0400
Date: Thu, 10 Apr 2008 13:58:00 -0700
From: sukadev@us.ibm.com
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Containers <containers@lists.osdl.org>, clg@fr.ibm.com,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][PATCH 0/7] Clone PTS namespace
Message-ID: <20080410205800.GA12960@us.ibm.com>
References: <20080408215333.GA8799@us.ibm.com> <47FC138B.4070408@zytor.com> <1207779313.16926.12.camel@x61.ebiederm.org> <20080410015955.GA18227@sergelap.austin.rr.com> <1207812980.7509.25.camel@x61.ebiederm.org> <20080410164436.GA6434@sergelap.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410164436.GA6434@sergelap.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn [serue@us.ibm.com] wrote:
| > 
| > Further what I did for the network namespace should easily handle the
| > uid/gid namespace and should be a good starting place for a general
| > device namespace.
| 
| Agreed.  What's the git url and which branch do i use for your proof
| of concept tree?  I'll do the userns patch on top of that.  I assume
| Suka will do the same for ptys?
| 

Sure.

BTW, can we push the following 3 helper patches in the set. I believe
they will be required to support multiple pts namespaces, even if
the actual way we do it is not final yet.

        [PATCH 1/7]: Propagate error code from devpts_pty_new
        [PATCH 2/7]: Factor out PTY index allocation
        [PATCH 3/7]: Enable multiple mounts of /dev/pts

Sukadev
