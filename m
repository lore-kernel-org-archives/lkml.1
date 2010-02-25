Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862Ab0BYVav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:30:51 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60893 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933805Ab0BYVas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:30:48 -0500
Date: Thu, 25 Feb 2010 22:30:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dream: camera: msm_camera: fix some code
 style issues
Message-ID: <20100225213031.GJ7645@elf.ucw.cz>
References: <1267132380-14916-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267132380-14916-1-git-send-email-chihau@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-02-25 18:13:00, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some code style issues like else staments after the close
> braces '}' and to use __func__ instead of __FUNCTION__.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

ACK.

> ---
>  drivers/staging/dream/camera/msm_camera.c |   37 ++++++++++++++---------------
>  1 files changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/staging/dream/camera/msm_camera.c b/drivers/staging/dream/camera/msm_camera.c
> index 4f808dc..925e16c 100644
> --- a/drivers/staging/dream/camera/msm_camera.c
> +++ b/drivers/staging/dream/camera/msm_camera.c
> @@ -670,7 +670,7 @@ static int msm_get_stats(struct msm_sync *sync, void __user *arg)
>  					&(stats.fd));
>  			if (!stats.buffer) {
>  				pr_err("%s: msm_pmem_stats_ptov_lookup error\n",
> -					__FUNCTION__);
> +					__func__);
>  				rc = -EINVAL;
>  				goto failure;
>  			}
> @@ -718,8 +718,7 @@ static int msm_get_stats(struct msm_sync *sync, void __user *arg)
>  					buf.fmain.buffer =
>  						(unsigned long)region.vaddr;
>  					buf.fmain.fd = region.fd;
> -				}
> -				else {
> +				} else {
>  					pr_err("%s: pmem lookup failed\n",
>  						__func__);
>  					rc = -EINVAL;
> @@ -838,8 +837,8 @@ static int msm_ctrl_cmd_done(struct msm_control_device *ctrl_pmsm,
>  			kfree(qcmd);
>  			goto end;
>  		}
> -	}
> -	else ctrlcmd->value = NULL;
> +	} else
> +		ctrlcmd->value = NULL;
>  
>  end:
>  	CDBG("msm_ctrl_cmd_done: end rc = %d\n", rc);
> @@ -876,7 +875,7 @@ static int msm_config_vfe(struct msm_sync *sync, void __user *arg)
>  					MSM_PMEM_AEC_AWB, &region[0],
>  					NUM_WB_EXP_STAT_OUTPUT_BUFFERS);
>  		if (!axi_data.bufnum1) {
> -			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
> +			pr_err("%s: pmem region lookup error\n", __func__);
>  			return -EINVAL;
>  		}
>  		axi_data.region = &region[0];
> @@ -888,7 +887,7 @@ static int msm_config_vfe(struct msm_sync *sync, void __user *arg)
>  					MSM_PMEM_AF, &region[0],
>  					NUM_AF_STAT_OUTPUT_BUFFERS);
>  		if (!axi_data.bufnum1) {
> -			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
> +			pr_err("%s: pmem region lookup error\n", __func__);
>  			return -EINVAL;
>  		}
>  		axi_data.region = &region[0];
> @@ -899,7 +898,7 @@ static int msm_config_vfe(struct msm_sync *sync, void __user *arg)
>  		break;
>  	default:
>  		pr_err("%s: unknown command type %d\n",
> -			__FUNCTION__, cfgcmd.cmd_type);
> +			__func__, cfgcmd.cmd_type);
>  		return -EINVAL;
>  	}
>  
> @@ -928,7 +927,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
>  			msm_pmem_region_lookup(&sync->frame, pmem_type,
>  				&region[0], 8);
>  		if (!axi_data.bufnum1) {
> -			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
> +			pr_err("%s: pmem region lookup error\n", __func__);
>  			return -EINVAL;
>  		}
>  		break;
> @@ -939,7 +938,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
>  			msm_pmem_region_lookup(&sync->frame, pmem_type,
>  				&region[0], 8);
>  		if (!axi_data.bufnum2) {
> -			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
> +			pr_err("%s: pmem region lookup error\n", __func__);
>  			return -EINVAL;
>  		}
>  		break;
> @@ -950,7 +949,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
>  			msm_pmem_region_lookup(&sync->frame, pmem_type,
>  				&region[0], 8);
>  		if (!axi_data.bufnum1) {
> -			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
> +			pr_err("%s: pmem region lookup error\n", __func__);
>  			return -EINVAL;
>  		}
>  
> @@ -959,7 +958,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
>  			msm_pmem_region_lookup(&sync->frame, pmem_type,
>  				&region[axi_data.bufnum1], 8);
>  		if (!axi_data.bufnum2) {
> -			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
> +			pr_err("%s: pmem region lookup error\n", __func__);
>  			return -EINVAL;
>  		}
>  		break;
> @@ -970,7 +969,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
>  			msm_pmem_region_lookup(&sync->frame, pmem_type,
>  				&region[0], 8);
>  		if (!axi_data.bufnum2) {
> -			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
> +			pr_err("%s: pmem region lookup error\n", __func__);
>  			return -EINVAL;
>  		}
>  		break;
> @@ -981,7 +980,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
>  
>  	default:
>  		pr_err("%s: unknown command type %d\n",
> -			__FUNCTION__, cfgcmd->cmd_type);
> +			__func__, cfgcmd->cmd_type);
>  		return -EINVAL;
>  	}
>  
> @@ -1047,7 +1046,7 @@ static int __msm_put_frame_buf(struct msm_sync *sync,
>  			rc = sync->vfefn.vfe_config(&cfgcmd, &pphy);
>  	} else {
>  		pr_err("%s: msm_pmem_frame_vtop_lookup failed\n",
> -			__FUNCTION__);
> +			__func__);
>  		rc = -EINVAL;
>  	}
>  
> @@ -1131,7 +1130,7 @@ static int msm_stats_axi_cfg(struct msm_sync *sync,
>  		break;
>  	default:
>  		pr_err("%s: unknown command type %d\n",
> -			__FUNCTION__, cfgcmd->cmd_type);
> +			__func__, cfgcmd->cmd_type);
>  		return -EINVAL;
>  	}
>  
> @@ -1140,7 +1139,7 @@ static int msm_stats_axi_cfg(struct msm_sync *sync,
>  			msm_pmem_region_lookup(&sync->stats, pmem_type,
>  				&region[0], NUM_WB_EXP_STAT_OUTPUT_BUFFERS);
>  		if (!axi_data.bufnum1) {
> -			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
> +			pr_err("%s: pmem region lookup error\n", __func__);
>  			return -EINVAL;
>  		}
>  		axi_data.region = &region[0];
> @@ -1177,7 +1176,7 @@ static int msm_put_stats_buffer(struct msm_sync *sync, void __user *arg)
>  			cfgcmd.cmd_type = CMD_STATS_AF_BUF_RELEASE;
>  		else {
>  			pr_err("%s: invalid buf type %d\n",
> -				__FUNCTION__,
> +				__func__,
>  				buf.type);
>  			rc = -EINVAL;
>  			goto put_done;
> @@ -1223,7 +1222,7 @@ static int msm_axi_config(struct msm_sync *sync, void __user *arg)
>  
>  	default:
>  		pr_err("%s: unknown command type %d\n",
> -			__FUNCTION__,
> +			__func__,
>  			cfgcmd.cmd_type);
>  		return -EINVAL;
>  	}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
