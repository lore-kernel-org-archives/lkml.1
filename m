Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbYA2Ilv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbYA2Ilv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 03:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYA2Ill
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 03:41:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYA2Ilk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 03:41:40 -0500
Subject: Re: [2.6 patch] make gfs2_glock_hold() static
From: Steven Whitehouse <swhiteho@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080128221134.GZ8767@does.not.exist>
References: <20080128221134.GZ8767@does.not.exist>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 29 Jan 2008 08:37:18 +0000
Message-Id: <1201595838.22038.324.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the GFS2 -nmw git tree. Thanks,

Steve.

On Tue, 2008-01-29 at 00:11 +0200, Adrian Bunk wrote:
> gfs2_glock_hold() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  fs/gfs2/glock.c |    2 +-
>  fs/gfs2/glock.h |    1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> f04fbd054a051a564a3138e0e02b7423acf45a06 
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index 80e09c5..e18f251 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -197,7 +197,7 @@ static void glock_free(struct gfs2_glock *gl)
>   *
>   */
>  
> -void gfs2_glock_hold(struct gfs2_glock *gl)
> +static void gfs2_glock_hold(struct gfs2_glock *gl)
>  {
>  	atomic_inc(&gl->gl_ref);
>  }
> diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
> index b16f604..0724076 100644
> --- a/fs/gfs2/glock.h
> +++ b/fs/gfs2/glock.h
> @@ -77,7 +77,6 @@ static inline int gfs2_glock_is_blocking(struct gfs2_glock *gl)
>  int gfs2_glock_get(struct gfs2_sbd *sdp,
>  		   u64 number, const struct gfs2_glock_operations *glops,
>  		   int create, struct gfs2_glock **glp);
> -void gfs2_glock_hold(struct gfs2_glock *gl);
>  int gfs2_glock_put(struct gfs2_glock *gl);
>  void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state, unsigned flags,
>  		      struct gfs2_holder *gh);
> 

