Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZIIRI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZIIRI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZIIRI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:08:56 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:54766 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752908AbZIIRIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:08:55 -0400
Date: Wed, 9 Sep 2009 13:07:52 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Jeff Layton <jlayton@redhat.com>
cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
In-Reply-To: <20090909125352.1c7b57d2@tlielax.poochiereds.net>
Message-ID: <alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1> <20090905071052.50501826@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1> <20090909125352.1c7b57d2@tlielax.poochiereds.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Jeff Layton wrote:

> My suspicion would be that the server needs to perform an oplock break
> to another client before it can send the response. The only way I know
> how to tell that is to sniff all SMB traffic on the server and watch
> for oplock break calls to other clients when these stalls occur.

That could be tested by switching them off right? If I do

echo 0 >/proc/fs/cifs/OplockEnabled

and then remount the volume it should switch off oplocks?

This has no effect on the stalls.

